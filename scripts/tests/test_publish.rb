require 'json'
require 'minitest/autorun'
require 'open3'
require 'tmpdir'
require 'yaml'

class PublishTest < Minitest::Test
  def run_resolver(overrides = {}, pr_changes = {}, files = [{ filename: 'Formula/code-a-cv.rb', status: 'modified' }])
    workflow = YAML.load_file(File.expand_path('../../.github/workflows/publish.yml', __dir__))
    script = workflow.fetch('jobs').fetch('resolve').fetch('steps').first.fetch('run')
    Dir.mktmpdir do |dir|
      pr = { number: 12, state: 'open', draft: false, base: { ref: 'main' },
             head: { sha: 'tested-sha', repo: { full_name: 'voxvanhieu/homebrew-tap' } },
             user: { login: 'voxvanhieu' } }.merge(pr_changes)
      File.write("#{dir}/gh", <<~SH)
        #!/bin/bash
        case "$*" in
          */files) printf '%s' "$MOCK_FILES" ;;
          *--method*) printf '%s' "$MOCK_PRS" ;;
          *) printf '%s' "$MOCK_PR" ;;
        esac
      SH
      File.chmod(0755, "#{dir}/gh")
      env = { 'PATH' => "#{dir}:#{ENV.fetch('PATH')}", 'GITHUB_OUTPUT' => "#{dir}/output",
              'EVENT_NAME' => 'workflow_run', 'GITHUB_REF' => 'refs/heads/main',
              'GITHUB_REPOSITORY' => 'voxvanhieu/homebrew-tap', 'GITHUB_REPOSITORY_OWNER' => 'voxvanhieu',
              'TESTED_SHA' => 'tested-sha', 'TESTED_BRANCH' => 'code-a-cv-0.3.0',
              'REQUESTED_PR' => '', 'REQUESTED_SHA' => '', 'MOCK_PRS' => [pr].to_json,
              'MOCK_PR' => pr.to_json, 'MOCK_FILES' => files.to_json }.merge(overrides)
      output, status = Open3.capture2e(env, 'bash', '-euo', 'pipefail', '-c', script)
      result = File.exist?("#{dir}/output") ? File.read("#{dir}/output") : ''
      [status.success?, result, output]
    end
  end

  def test_publishes_tested_owner_formula
    success, output = run_resolver
    assert success
    assert_equal "number=12\nsha=tested-sha\n", output
  end

  def test_skips_untrusted_or_stale_changes
    [{ 'TESTED_SHA' => 'old-sha' }, { 'TESTED_BRANCH' => 'dependabot/actions' }].each do |env|
      assert_equal '', run_resolver(env)[1]
    end
    [{ user: { login: 'contributor' } }, { draft: true },
     { head: { sha: 'tested-sha', repo: { full_name: 'other/fork' } } }].each do |pr|
      assert_equal '', run_resolver({}, pr)[1]
    end
    assert_equal '', run_resolver({}, {}, [{ filename: '.github/workflows/tests.yml', status: 'modified' }])[1]
    assert_equal '', run_resolver({}, {}, [{ filename: 'Formula/code-a-cv.rb', status: 'removed' }])[1]
  end

  def test_manual_dispatch_resolves_and_checks_current_sha
    success, output = run_resolver({ 'EVENT_NAME' => 'workflow_dispatch', 'REQUESTED_PR' => '12' })
    assert success
    assert_equal "number=12\nsha=tested-sha\n", output
    success, output = run_resolver({ 'EVENT_NAME' => 'workflow_dispatch', 'REQUESTED_PR' => '12', 'REQUESTED_SHA' => 'stale' })
    refute success
    assert_empty output
  end
end
