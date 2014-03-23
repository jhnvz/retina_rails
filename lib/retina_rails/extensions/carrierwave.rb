module RetinaRails
  module Extensions
    module CarrierWave
      module Mount

        def self.included base
          base.module_eval do
            alias_method :original_mount_uploader, :mount_uploader

            ##
            # Serialize retina_dimensions
            # if mounted to class has a retina_dimensions column
            #
            def mount_uploader(*args)
              original_mount_uploader(*args)

              serialize :retina_dimensions if columns_hash.has_key?('retina_dimensions')
            end
          end
        end

      end # Mount
    end # CarrierWave
  end # Extensions
end # RetinaRails
