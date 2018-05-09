class BankAccountSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner, :created_at, :children, :kind

  def owner
    object.ownerable.name
  end
end
