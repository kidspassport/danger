module Danger
  class PullRequestForBranch
    attr_reader :branch

    def initialize(branch)
      @branch = branch
    end

    def pr_url
      prs = client.pull_requests
      url = nil
      prs.each do |pr|
        if pr.head.ref == branch
          url = pr.html_url
        end
      end
      url
    end

    def pr_id
      prs = client.pull_requests
      id = nil
      prs.each do |pr|
        if pr.head.ref == branch
          id = pr.id
        end
      end
      id
    end

    def client
      require "octokit"
      Octokit::Client.new(access_token: ENV["DANGER_GITHUB_API_TOKEN"], api_endpoint: api_url)
    end

    def api_url
      ENV.fetch("DANGER_GITHUB_API_HOST") do
        ENV.fetch("DANGER_GITHUB_API_BASE_URL") do
          "https://api.github.com/".freeze
        end
      end
    end
  end
end
