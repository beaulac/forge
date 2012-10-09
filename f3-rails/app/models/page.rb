class Page < ActiveRecord::Base
  # Scopes, Attrs, Etc.
  default_scope :order => "list_order"
  scope :published, where(:published => true)
  scope :find_for_menu, published.where("parent_id IS NULL AND show_in_menu = ?", true).includes(:subpages)
  scope :top, where(:parent_id => nil)

  # Relationships
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  has_many :subpages, :class_name => "Page", :foreign_key => "parent_id", :dependent => :destroy, :order => "list_order"

  # Validations
  before_validation :set_slug_and_path
  validates_presence_of :title, :content
  validates_presence_of :slug, :message => "must exist in order to have a properly generated URL."
  validates_uniqueness_of :slug, :scope => :parent_id
  validate :path_is_not_route

  # Return siblings if subpages aren't available
  def subpages_for_menu
    if subpages.blank?
      Page.where(:published => true, :show_in_menu => true, :parent_id => parent_id) unless parent_id.blank?
    else
      subpages.where(:published => true, :show_in_menu => true)
    end
  end

  # this will be included in rails automatically soon
  def self.find_by_slug!(slug)
    self.find_by_slug(slug) or raise ActiveRecord::RecordNotFound, "could not find page '#{slug}'"
  end

  def parents
    parent, parents = self.parent, []
    while parent
      parents << parent
      parent = parent.parent
    end
    return parents
  end

  def breadcrumb(separator = ' > ')
    parent, pages = self.parent, [self.title]
    while parent
      pages << parent.title
      parent = parent.parent
    end
    pages.reverse.join(separator)
  end

  def top_parent
    parent, parents = self.parent, [self]
    while parent
      parents << self
      parent = parent.parent
    end
    return parents.last
  end

  def list_title
    title = self.title.size > 64 ? self.title[0..64].strip + '...' : self.title
    title = self.published? ? title : title + " (Draft)"
    return title
  end

  def self.reorder!(list, parent_id)
    list.each_with_index do |id,order|
      page = Page.find_by_id(id)
      page.parent_id = parent_id unless parent_id.blank?
      page.list_order = order and page.save unless page.blank?
    end
  end

  protected
    def path_is_not_route
      match = Rails.application.routes.recognize_path(path, :method => :get) rescue nil
      errors.add(:base, "There's already something happening at #{MySettings.site_url}#{path}.  Try giving the page a different name.") if match && !match[:slugs]
    end

    def set_slug_and_path
      self.slug = self.title.parameterize

      parent, pages = self.parent, [self.slug]
      while parent
        pages << parent.slug
        parent = parent.parent
      end
      self.path = "/" + pages.reverse.join('/')
    end
end
