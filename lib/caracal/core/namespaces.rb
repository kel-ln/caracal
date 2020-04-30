require 'caracal/core/models/namespace_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to registering and
    # retrieving namespaces.
    #
    module Namespaces
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Class Methods
          #-------------------------------------------------------------

          def self.default_namespaces
            [
              { prefix: 'xmlns:wpc',    href: "http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"      },
              { prefix: 'xmlns:cx',     href: "http://schemas.microsoft.com/office/drawing/2014/chartex"                },
              { prefix: 'xmlns:cx1',    href: "http://schemas.microsoft.com/office/drawing/2015/9/8/chartex"            },
              { prefix: 'xmlns:cx2',    href: "http://schemas.microsoft.com/office/drawing/2015/10/21/chartex"          },
              { prefix: 'xmlns:cx3',    href: "http://schemas.microsoft.com/office/drawing/2016/5/9/chartex"            },
              { prefix: 'xmlns:cx4',    href: "http://schemas.microsoft.com/office/drawing/2016/5/10/chartex"           },
              { prefix: 'xmlns:cx5',    href: "http://schemas.microsoft.com/office/drawing/2016/5/11/chartex"           },
              { prefix: 'xmlns:cx6',    href: "http://schemas.microsoft.com/office/drawing/2016/5/12/chartex"           },
              { prefix: 'xmlns:cx7',    href: "http://schemas.microsoft.com/office/drawing/2016/5/13/chartex"           },
              { prefix: 'xmlns:cx8',    href: "http://schemas.microsoft.com/office/drawing/2016/5/14/chartex"           },
              { prefix: 'xmlns:mc',     href: "http://schemas.openxmlformats.org/markup-compatibility/2006"             },
              { prefix: 'xmlns:aink',   href: "http://schemas.microsoft.com/office/drawing/2016/ink"                    },
              { prefix: 'xmlns:am3d',   href: "http://schemas.microsoft.com/office/drawing/2017/model3d"                },
              { prefix: 'xmlns:o',      href: "urn:schemas-microsoft-com:office:office"                                 },
              { prefix: 'xmlns:r',      href: "http://schemas.openxmlformats.org/officeDocument/2006/relationships"     },
              { prefix: 'xmlns:m',      href: "http://schemas.openxmlformats.org/officeDocument/2006/math"              },
              { prefix: 'xmlns:v',      href: "urn:schemas-microsoft-com:vml"                                           },
              { prefix: 'xmlns:wp14',   href: "http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"     },
              { prefix: 'xmlns:wp',     href: "http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"  },
              { prefix: 'xmlns:w10',    href: "urn:schemas-microsoft-com:office:word"                                   },
              { prefix: 'xmlns:w',      href: "http://schemas.openxmlformats.org/wordprocessingml/2006/main"            },
              { prefix: 'xmlns:w14',    href: "http://schemas.microsoft.com/office/word/2010/wordml"                    },
              { prefix: 'xmlns:w15',    href: "http://schemas.microsoft.com/office/word/2012/wordml"                    },
              { prefix: 'xmlns:w16cid', href: "http://schemas.microsoft.com/office/word/2016/wordml/cid"                },
              { prefix: 'xmlns:w16se',  href: "http://schemas.microsoft.com/office/word/2015/wordml/symex"              },
              { prefix: 'xmlns:wpg',    href: "http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"       },
              { prefix: 'xmlns:wpi',    href: "http://schemas.microsoft.com/office/word/2010/wordprocessingInk"         },
              { prefix: 'xmlns:wne',    href: "http://schemas.microsoft.com/office/word/2006/wordml"                    },
              { prefix: 'xmlns:wps',    href: "http://schemas.microsoft.com/office/word/2010/wordprocessingShape"       }
            ]
          end


          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          #============== ATTRIBUTES ==========================

          def namespace(options={}, &block)
            model = Caracal::Core::Models::NamespaceModel.new(options, &block)
            if model.valid?
              ns = register_namespace(model)
            else
              raise Caracal::Errors::InvalidModelError, 'namespace must specify the :prefix and :href attributes.'
            end
            ns
          end


          #============== GETTERS =============================

          def namespaces
            @namespaces ||= []
          end

          def find_namespace(prefix)
            namespaces.find { |ns| ns.matches?(prefix) }
          end


          #============== REGISTRATION ========================

          def register_namespace(model)
            unless ns = find_namespace(model.namespace_prefix)
              namespaces << model
              ns = model
            end
            ns
          end

          def unregister_namespace(prefix)
            if ns = find_namespace(prefix)
              namespaces.delete(ns)
            end
          end

        end
      end
    end

  end
end
