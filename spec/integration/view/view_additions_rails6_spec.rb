require './spec/rails_helper'

if ActionPack::VERSION::MAJOR == 6
  describe ActionView::PathResolver do
    let(:resolver) { ActionView::PathResolver.new }

    context '#extract_handler_and_format' do
      subject(:template_format) do
        _, format = resolver.extract_handler_and_format("application.#{template_extension}", nil)
        format.to_s
      end

      context 'when only handler and format are present' do
        let(:template_extension) { 'html.erb' }

        it { expect(template_format).to eq 'text/html' }
      end

      context 'when handler, format and version are present' do
        let(:template_extension) { 'json.v1.jbuilder' }

        it { expect(template_format).to eq 'application/json' }
      end

      context 'when handler, format and locale are present' do
        let(:template_extension) { 'en.json.jbuilder' }

        it { expect(template_format).to eq 'application/json' }
      end

      context 'when handler, format, locale and version are present' do
        let(:template_extension) { 'en.json.v1.jbuilder' }

        it { expect(template_format).to eq 'application/json' }
      end

      context 'when handler, format, variant and version are present' do
        let(:template_extension) { 'application.json+tablet.v1.jbuilder' }

        it { expect(template_format).to eq 'application/json' }
      end
    end
  end
end
