# frozen_string_literal: true

title 'clion archives profile'

control 'clion archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/clion.sh') do
    it { should exist }
  end
  # describe file('/usr/local/jetbrains/clion-*/bin/clion.sh') do
  #   it { should exist }
  # end
  describe file('/usr/share/applications/clion.desktop') do
    it { should exist }
  end
  describe file('/usr/local/bin/clion') do
    it { should exist }
  end
end
