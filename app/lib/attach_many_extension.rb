module AttachManyExtension
  module ClassMethods
    def has_many_attached(arg)
      super

      delete_ids_attr = "delete_#{arg.to_s.singularize}_ids"
      public_send(:attr_accessor, delete_ids_attr)

      define_method :del_attr_nm do delete_ids_attr end
      define_method :atch_attr_nm do arg end
      define_method :attachings do public_send(arg) end
    end
  end
  def self.included(base) = base.extend(ClassMethods)

  def update(params)
    params[del_attr_nm]&.each {|id| attachings.find_by_id(id)&.delete }
    params[atch_attr_nm]&.each {|item| attachings.attach(item) }
    super params.except(atch_attr_nm, del_attr_nm)
  end
end
