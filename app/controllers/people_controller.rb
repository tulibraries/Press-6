# frozen_string_literal: true

class PeopleController < ApplicationController
  def index
    @people = Person.all.group_by { |t| t.department }.sort_by { |x, y| y.sort_by { |z| [z.head, z.name] } }
  end
end
