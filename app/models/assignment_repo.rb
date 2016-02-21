class AssignmentRepo < ActiveRecord::Base
  update_index('stafftools#assignment_repo') { self }

  has_one :organization, -> { unscope(where: :deleted_at) }, through: :assignment

  belongs_to :assignment
  belongs_to :repo_access
  belongs_to :user

  validates :assignment, presence: true

  validates :github_repo_id, presence:   true
  validates :github_repo_id, uniqueness: true

  def creator
    assignment.creator
  end

  def private?
    !assignment.public_repo?
  end

  def github_team_id
    repo_access.present? ? repo_access.github_team_id : nil
  end

  def repo_name
    github_user = GitHubUser.new(user.github_client, user.uid)
    "#{assignment.slug}-#{github_user.login(headers: no_cache_headers)}"
  end

  def starter_code_repo_id
    assignment.starter_code_repo_id
  end
end
