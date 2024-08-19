module LecturesHelper
    def getPercent(number) 
        if number.present?
            calPercent = number/5.to_f * 100
            # calPercent = number/10.to_f * 100
            percent = calPercent.round
            return percent.to_s
        else
            return 0
        end
    end     
end
