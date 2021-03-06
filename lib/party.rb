module Placebo

  class Party < PlaceboResource

    def resource_path(id = nil)
      [self.class.base_uri, 'party', id].compact.join('/')
    end

    def self.find(id, options = {})
      options[:possible_resource_types] = ['person','organization']
      super
    end

    def self.search(query, opts = {})
      self.where(opts.merge({
        :q => query,
        :possible_resource_types => ['contact','person','organization']
      }))
    end

  end

  class Person < Party

    def write_path(id = nil)
      [self.class.base_uri, 'person', id].compact.join('/')
    end

  end

  class Organization < Party

    def write_path(id = nil)
      [self.class.base_uri, 'organization', id].compact.join('/')
    end

  end

  class PartyChild < PlaceboResource

    def write_path(id = nil)
      raise NoParent unless self['party_id']
      [self.class.base_uri, 'party', self['party_id'], self.class.resource_name, id].compact.join('/')
    end

  end

  class CustomField < PartyChild

    def self.xml_name
      'customField'
    end

  end

  class HistoryItem < PartyChild

    def write_path(id=nil)
      raise NoParent unless self['party_id']
      [self.class.base_uri, 'party', self['party_id'], 'history', id].compact.join('/')
    end

    def self.xml_name
      'historyItem'
    end

  end

  class Kase < PartyChild
  end

  class Opportunity < PartyChild
  end

  class Tag < PlaceboResource

    def write_path(id = nil)
      raise NoParent unless self['party_id']
      [self.class.base_uri, 'party', self['party_id'], self.class.resource_name, self['name']].compact.join('/')
    end

  end

end