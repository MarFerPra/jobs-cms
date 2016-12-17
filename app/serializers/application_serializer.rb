class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :cover, :cv
end
