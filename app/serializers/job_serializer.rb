class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :active, :category, :keywords, :applications, :contract

  def contract
    object&.contract&.type_of
  end

end
