require './spec/rails_helper'

if ActionPack::VERSION::MAJOR == 5
  describe ActionView::PathResolver do
    let(:resolver) { ActionView::PathResolver.new }

    context '#extract_handler_and_format_and_variant' do
      subject do
        resolver.extract_handler_and_format_and_variant("application.#{extension}", nil)
      end

      let(:variant) { subject[2].to_s }
      let(:format) { subject[1].to_s }
      let(:handler) { subject[0] }

      context 'when only handler and format are present' do
        let(:extension) { 'html.erb' }

        it do
          expect(format).to eq 'text/html'
          expect(variant).to be_empty
          expect(handler).to be_a ActionView::Template::Handlers::ERB
        end
      end

      context 'when handler, format and version are present' do
        let(:extension) { 'json.v1.jbuilder' }

        it do
          expect(format).to eq 'application/json'
          expect(variant).to be_empty
          expect(handler).to be_a ActionView::Template::Handlers::Raw
        end
      end

      context 'when handler, format and locale are present' do
        let(:extension) { 'en.json.jbuilder' }

        it do
          expect(format).to eq 'application/json'
          expect(variant).to be_empty
          expect(handler).to be_a ActionView::Template::Handlers::Raw
        end
      end

      context 'when handler, format, locale and version are present' do
        let(:extension) { 'en.json.v1.jbuilder' }

        it do
          expect(format).to eq 'application/json'
          expect(variant).to be_empty
          expect(handler).to be_a ActionView::Template::Handlers::Raw
        end
      end

      context 'when handler, format, variant and version are present' do
        let(:extension) { 'application.json+tablet.v1.jbuilder' }

        it do
          expect(format).to eq 'application/json'
          expect(variant).to eq 'tablet'
          expect(handler).to be_a ActionView::Template::Handlers::Raw
        end
      end
    end
  end
end
