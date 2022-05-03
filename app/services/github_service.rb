class GithubService
  def self.current_sha
    `git rev-parse HEAD`.gsub("\n", "")
  end
end
