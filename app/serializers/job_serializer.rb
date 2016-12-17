class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :active
end
