class GithubService
  def self.get_current_sha
    `git rev-parse HEAD`.gsub("\n", '')
  end
end