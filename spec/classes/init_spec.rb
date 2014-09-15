require 'spec_helper'
describe 'openwsman' do

  context 'with defaults for all parameters' do
    it { should contain_class('openwsman') }
  end
end
