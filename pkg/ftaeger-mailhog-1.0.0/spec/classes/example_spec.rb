require 'spec_helper'

describe 'mailhog' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "mailhog class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('mailhog::params') }
          it { is_expected.to contain_class('mailhog::install').that_comes_before('mailhog::config') }
          it { is_expected.to contain_class('mailhog::config') }
          it { is_expected.to contain_class('mailhog::service').that_subscribes_to('mailhog::config') }

          it { is_expected.to contain_service('mailhog') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'mailhog class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('mailhog') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
