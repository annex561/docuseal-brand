# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Branding', type: :request do
  describe 'GET submission signing page' do
    let(:account) { create(:account) }
    let(:user) { create(:user, account: account) }
    let(:template) { create(:template, account: account, author: user) }
    let(:submission) { create(:submission, :with_submitters, template: template, account: account) }
    let(:submitter) { submission.submitters.first }

    context 'with LAMP Logistics host' do
      it 'includes LAMP Logistics brand' do
        get "/s/#{submitter.slug}", headers: { 'Host' => 'sign.lampslogistics.com' }

        doc = Nokogiri::HTML.parse(response.body)
        visible_text = doc.css('body').text
        expect(visible_text).to include('LAMP Logistics')
        expect(visible_text).not_to include('DocuSeal')
        expect(visible_text).not_to include('ANEX Holdings')

        expect(doc.at_css('title')&.text).to eq('LAMP Logistics')
        expect(doc.at_css('img[alt="LAMP Logistics"]')).to be_present
        expect(doc.at_css('[data-brand-name="LAMP Logistics"]')).to be_present
        expect(response.body).to include('https://github.com/annex561/docuseal-brand')
      end
    end

    context 'with unknown host' do
      it 'includes ANEX Holdings brand' do
        get "/s/#{submitter.slug}", headers: { 'Host' => 'example.com' }

        doc = Nokogiri::HTML.parse(response.body)
        visible_text = doc.css('body').text
        expect(visible_text).to include('ANEX Holdings')
        expect(visible_text).not_to include('LAMP Logistics')

        expect(doc.at_css('title')&.text).to eq('ANEX Holdings')
        expect(doc.at_css('img[alt="ANEX Holdings"]')).to be_present
        expect(doc.at_css('[data-brand-name="ANEX Holdings"]')).to be_present
        expect(response.body).to include('https://github.com/annex561/docuseal-brand')
      end
    end
  end
end
