class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :active, :category, :keywords, :applications
end
