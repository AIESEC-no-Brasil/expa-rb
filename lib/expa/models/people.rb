class EXPA::People < ActiveBase::People
  class << self
    def find_by_id(id)

    end

    def get_attributes(id)

    end

    def get_applications(id)
      
    end

    def list_by_country(country_id, offset = 0, limit = 1000, filters = {})

    end

    def list_by_commitee(committee, offset = 0, limit = 1000, filter = {})

    end

    #@param status [String]
    def set_filters_status(status)
      @filters[:status] = status
    end

    def clean_filters_status
      @filters.slice!(:status) if @filters.has_key?(:status)
    end




    private

    def get_filters
      @filters
    end

    def erase_filters
      @filters = nil
    end
  end
end