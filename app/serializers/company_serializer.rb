class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :cnpj, :trade
end
