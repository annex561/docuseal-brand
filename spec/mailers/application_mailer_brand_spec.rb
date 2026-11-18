# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer do
  let(:account) { create(:account) }
  let(:user) { create(:user, account:) }

  def html_of(email)
    (email.html_part || email).body.decoded
  end

  def invitation_for(folder_name)
    folder = create(:template_folder, account:, author: user, name: folder_name)
    template = create(:template, account:, author: user, folder:)
    submission = create(:submission, :with_submitters, template:, created_by_user: user)

    SubmitterMailer.invitation_email(submission.submitters.first).deliver_now
  end

  it 'brands submitter emails by the template folder' do
    email = invitation_for('Trucking — LAMP Logistics')

    expect(html_of(email)).to include('LAMP Logistics - Secure e-signature')
    expect(html_of(email)).not_to include('DocuSeal')
  end

  it 'uses the configured default brand for submitter emails in unmapped folders' do
    email = invitation_for('Some Other Folder')

    expect(html_of(email)).to include('ANEX Holdings - Secure e-signature')
  end

  it 'does not leak the brand past the mail call' do
    expect { invitation_for('Trucking — LAMP Logistics') }.not_to(change(Current, :brand))
  end

  it 'keeps DocuSeal for emails with no submission' do
    user.send_reset_password_instructions
    email = ActionMailer::Base.deliveries.last

    expect(html_of(email)).to include('DocuSeal - Secure e-signature')
  end

  it 'keeps the HTML part ASCII so links stay unencoded' do
    user.send_reset_password_instructions
    email = ActionMailer::Base.deliveries.last

    expect(email.body.encoded[/href="([^"]+)"/, 1]).to include('reset_password_token')
  end

  it 'keeps the signing certificate name off the request brand' do
    certs = Current.set(brand: Brand.new('lamp')) { GenerateCertificate.call }

    expect(certs[:cert].subject.to_s).to include('CN=DocuSeal')
  end
end
