require 'rspec/rails'

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/support/cassettes'

  c.default_cassette_options = {
    serialize_with: :json,
    preserve_exact_body_bytes:  true,
    decode_compressed_response: true,
    record: ENV['TRAVIS'] ? :none : :once
  }

  # Application id
  c.filter_sensitive_data('<TEST_APPLICATION_GITHUB_CLIENT_ID>') do
    application_github_client_id
  end

  # Teacher
  c.filter_sensitive_data('<TEST_CLASSROOM_TEACHER_GITHUB_ID>') do
    classroom_teacher_github_id
  end

  c.filter_sensitive_data('<TEST_CLASSROOM_TEACHER_GITHUB_TOKEN>') do
    classroom_teacher_github_token
  end

  # Student
  c.filter_sensitive_data('<TEST_CLASSROOM_STUDENT_GITHUB_ID>') do
    classroom_student_github_id
  end

  c.filter_sensitive_data('<TEST_CLASSROOM_STUDENT_GITHUB_TOKEN>') do
    classroom_student_github_token
  end

  # Orgs
  c.filter_sensitive_data('<TEST_CLASSROOM_PRIVATE_REPOS_ORGANIZATION_GITHUB_ID>') do
    classroom_private_repos_organization_github_id
  end

  c.filter_sensitive_data('<TEST_CLASSROOM_PRIVATE_REPOS_ORGANIZATION_GITHUB_LOGIN>') do
    classroom_private_repos_organization_github_login
  end

  c.filter_sensitive_data('<TEST_CLASSROOM_PUBLIC_REPOS_ORGANIZATION_GITHUB_ID>') do
    classroom_public_repos_organization_github_id
  end

  c.filter_sensitive_data('<TEST_CLASSROOM_PUBLIC_REPOS_ORGANIZATION_GITHUB_LOGIN') do
    classroom_public_repos_organization_github_login
  end

  c.hook_into :webmock
end

def application_github_client_id
  ENV.fetch 'GITHUB_CLIENT_ID', 'i' * 20
end

def classroom_teacher_github_id
  ENV.fetch 'TEST_CLASSROOM_TEACHER_GITHUB_ID', 8_675_309
end

def classroom_teacher_github_token
  ENV.fetch 'TEST_CLASSROOM_TEACHER_GITHUB_TOKEN', 'x' * 40
end

def classroom_student_github_id
  ENV.fetch 'TEST_CLASSROOM_STUDENT_GITHUB_ID', 42
end

def classroom_student_github_token
  ENV.fetch 'TEST_CLASSROOM_STUDENT_GITHUB_TOKEN', 'q' * 40
end

def classroom_private_repos_organization_github_id
  ENV.fetch 'TEST_CLASSROOM_OWNER_ORGANIZATION_GITHUB_ID', 1
end

def classroom_private_repos_organization_github_token
  ENV.fetch 'TEST_CLASSROOM_OWNER_ORGANIZATION_GITHUB_LOGIN', 'classroom-testing-org'
end

def classroom_public_repos_organization_github_id
  ENV.fetch 'TEST_CLASSROOM_OWNER_ORGANIZATION_GITHUB_ID', 1
end

def classroom_public_repos_organization_github_token
  ENV.fetch 'TEST_CLASSROOM_OWNER_ORGANIZATION_GITHUB_LOGIN', 'classroom-testing-org'
end

def oauth_client
  Octokit::Client.new(access_token: classroom_teacher_github_token)
end

def use_vcr_placeholder_for(text, replacement)
  VCR.configure do |c|
    c.define_cassette_placeholder(replacement) do
      text
    end
  end
end
