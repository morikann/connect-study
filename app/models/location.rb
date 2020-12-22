class Location < ApplicationRecord
  geocoded_by :address
  has_many :study_events

  validates :name, presence: true
  validates :address, presence: true
  validate :valid_address

  private
  # 無効な住所で緯度経度が取得できない時にエラーを発生させる
  def valid_address
    if address.present? && latitude.blank? && longitude.blank?
      errors[:base] << "正しい住所を入力してください"
    end
  end
end
