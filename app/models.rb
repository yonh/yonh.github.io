#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'active_record'

class Post < ActiveRecord::Base
	belongs_to :category
end
class Category < ActiveRecord::Base
	has_many :posts, dependent: :destroy
	validates :title, presence: true,length: { minimum: 1 }
end
class History < ActiveRecord::Base
end
