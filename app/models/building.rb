# == Schema Information
#
# Table name: buildings
#
#  id              :integer          not null, primary key
#  name            :string
#  lat             :decimal(10, 6)
#  lng             :decimal(10, 6)
#  network_site_id :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Building < ActiveRecord::Base
  belongs_to :network_site
  has_one :company, through: :network_site
  has_many :sheets, dependent: :destroy
  has_many :import_jobs, dependent: :destroy
  has_many :test_network_graphs, dependent: :destroy

  validates :name, presence: true
  validates :network_site_id, presence: true
  validates :name, uniqueness: { scope: [:network_site_id] }

  def import_job_status
    job = self.import_jobs.order(created_at: :desc).first
    job.status if job.present? && job.try(:created_at) > 5.minutes.ago
  end
end
