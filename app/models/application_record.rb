class ApplicationRecord < ActiveRecord::Base
  include AttachManyExtension

  primary_abstract_class
end
