class PersonSerializer < ActiveModel::Serializer
  attributes :id, :name, :cpf, :birthdate
end
