module Veewee
  module Provider
    module Virtualbox
      module BoxCommand

        def destroy(option={})

          unless self.exists?
            env.ui.error "Error:: You tried to destroy a non-existing box '#{name}'"
            exit -1
          end

          # If it has a save state,remove that first

          if self.running?
            # Poweroff
            self.poweroff
            # Wait for it to happen
            sleep 2
          end

          command="#{@vboxcmd} unregistervm  '#{name}' --delete"
          env.ui.info command
          env.ui.info "Deleting vm #{name}"

          #Exec and system stop the execution here
          shell_exec("#{command}")
          sleep 1

          #if the disk was not attached when the machine was destroyed we also need to delete the disk
          pattern=name+"."
          #+definition.disk_format.downcase
          found=false
          command="#{@vboxcmd} list hdds -l"
          hdds=shell_exec("#{command}").stdout.split(/\n\n/)

          hdds.each do |hdd_text|
            location=hdd_text.split(/\n/).grep(/^Location/).first.split(':')[1].strip
            if location.match(/#{pattern}/)

              if File.exists?(location)
                command="#{@vboxcmd} closemedium disk '#{location}' --delete"
              else
                command="#{@vboxcmd} closemedium disk '#{location}'"
              end

              env.ui.info "Deleting disk #{location}"
              env.ui.info "#{command}"

              shell_exec("#{command}")

              if File.exists?(location)
                env.ui.info "We tried to delete the disk file via virtualbox '#{location} but failed"
                env.ui.info "Removing it manually"
                FileUtils.rm(location)
                exit -1
              end
              break
            end
          end
        end

      end #Module
    end #Module
  end #Module
end #Module