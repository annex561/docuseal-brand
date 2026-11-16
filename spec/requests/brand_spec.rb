# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Branding', type: :request do
  describe 'GET submission signing page' do
    let(:account) { create(:account) }
    let(:user) { create(:user, account: account) }
    let(:template) { create(:template, account: account, author: user) }
    let(:submission) { create(:submission, template: template, account: account) }
    let(:submitter) { submission.submitters.first }

    context 'with LAMP Logistics host' do
      it 'includes LAMP Logistics brand' do
        get "/s/#{submitter.slug}", headers: { 'Host' => 'sign.lampslogistics.com' }

        expect(response.body).to include('LAMP Logistics')
        expect(response.body).to include('https://github.com/annex561/docuseal-brand')
        expect(response.body).not_to include('DocuSeal')
          .or include('ANEX Holdings')
      end
    end

    context 'with unknown host' do
      it 'includes ANEX Holdings brand' do
        get "/s/#{submitter.slug}", headers: { 'Host' => 'example.com' }

        expect(response.body).to include('ANEX Holdings')
        expect(response.body).to include('https://github.com/annex561/docuseal-brand')
        expect(response.body).not_to include('LAMP Logistics')
      end
    end
  end
end
