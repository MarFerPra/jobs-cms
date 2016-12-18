class ApplicationSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :cover, :cv, :job
end
