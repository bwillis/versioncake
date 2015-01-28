require './spec/rails_helper'

describe ActionView::Base do
  let(:path) { ActionView::FileSystemResolver.new('./spec/fixtures') }
  let(:view_paths) { ActionView::PathSet.new([path]) }
  let(:view) { ActionView::Base.new(view_paths) }
  let(:version_override) { nil }
  subject { view.render(template: 'templates/versioned', versions: version_override) }

  context 'with a 0 version' do
    before { view.lookup_context.versions = [:v0] }

    it { is_expected.to eq 'template' }
  end

  context 'with the version override set' do
    let(:version_override) { :v1 }

    it { is_expected.to eq 'template v1' }
  end

  context 'with an older version in the lookup context' do
    before { view.lookup_context.versions = [:v2] }

    it { is_expected.to eq 'template v2' }
  end

  context 'with a v4 requested, but only highest templates is v3' do
    before { view.lookup_context.versions = [:v4,:v3,:v2,:v1] }

    it { is_expected.to eq 'template v3' }
  end
end
