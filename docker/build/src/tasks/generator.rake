# frozen-string-literal: true

require_relative '../lib/garner/generator'

namespace :gitops do
  desc 'Generate GitOps config'
  task :generate do
    Garner::Generator::GitOpsConfig.new.generate
  end
end
