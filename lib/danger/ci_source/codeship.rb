require "danger/request_sources/github/github"

module Danger

  class Codeship < CI
    def self.validates_as_ci?(env)
      env.key? "CI_BUILD_NUMBER"
    end

    def self.validates_as_pr?(env)
      value = env["CI_PULL_REQUEST"]
      !value.nil?
    end

    def supported_request_sources
      @supported_request_sources ||= [
        Danger::RequestSources::GitHub
      ]
    end

    def initialize(env)
      # CI
      # CI_BRANCH
      # CI_BUILD_NUMBER
      # CI_BUILD_URL
      # CI_COMMITTER_EMAIL
      # CI_COMMITTER_NAME
      # CI_COMMITTER_USERNAME
      # CI_COMMIT_ID
      # CI_MESSAGE
      # CI_NAME
      # CI_PULL_REQUEST
      # CI_REPO_NAME
      self.repo_url = env["CI_PULL_REQUEST"]

      pr_url = PullRequestForBranch.new(
        env["CI_BRANCH"]
      ).pr_url

      pr_id = PullRequestForBranch.new(
        env["CI_BRANCH"]
      ).pr_id

      if pr_id
        # The first one is an extra slash, ignore it
        self.repo_slug = "kidspassport/kidspassport"
        self.pull_request_id = pr_id

      else
        message = "Danger::Codeship.rb considers this a PR, " \
                  "but did not get enough information to get a repo slug" \
                  "and PR id.\n\n" \
                  "#{pr_id}" \
                  "PR path: #{pr_url}\n" \
                  "Keys: #{env.keys}"
        raise message.red
      end
    end
  end
end
