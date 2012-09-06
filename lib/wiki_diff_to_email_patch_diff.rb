module Redmine
  module WikiDiffToEmailPatchDiff
    def self.included(base)
      base.class_eval do
        def to_html_styles_inline
          words = self.words.collect{|word| h(word)}
          words_add = 0
          words_del = 0
          dels = 0
          del_off = 0
          diff.diffs.each do |diff|
            add_at = nil
            add_to = nil
            del_at = nil
            deleted = ""
            diff.each do |change|
              pos = change[1]
              if change[0] == "+"
                add_at = pos + dels unless add_at
                add_to = pos + dels
                words_add += 1
              else
                del_at = pos unless del_at
                deleted << ' ' + h(change[2])
                words_del  += 1
              end
            end
            if add_at
              words[add_at] = '<span style="background: #afa;">' + words[add_at]
              words[add_to] = words[add_to] + '</span>'
            end
            if del_at
              words.insert del_at - del_off + dels + words_add, '<span style="background: #faa;">' + deleted + '</span>'
              dels += 1
              del_off += words_del
              words_del = 0
            end
          end
          words.join(' ').html_safe
        end
      end
    end
  end
end
