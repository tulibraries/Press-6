# frozen_string_literal: true

module EventsHelper
  def group_date(date)
    year = date[0, 4]
    month = date[4, 5]
    formatted_date = year
    case month
    when "01" then full_month = "January"
    when "02" then full_month = "February"
    when "03" then full_month = "March"
    when "04" then full_month = "April"
    when "05" then full_month = "May"
    when "06" then full_month = "June"
    when "07" then full_month = "July"
    when "08" then full_month = "August"
    when "09" then full_month = "September"
    when "10" then full_month = "October"
    when "11" then full_month = "November"
    when "12" then full_month = "December"
    end
    formatted_date.prepend("#{full_month} ")
  end

  def date_range(starting, ending)
    # no time display (set to midmight)
    if starting.strftime("%H") == "00"
      if starting.strftime("%d") != ending.strftime("%d")
        "#{
      [
        starting.strftime('%a, %b'),
        starting.strftime('%d').to_i.ordinalize.to_s
      ].join(' ')}
      --
      #{
        [
          ending.strftime('%a, %h'),
          ending.strftime('%d').to_i.ordinalize.to_s
        ].join(' ')}"
      else # single day event
        [
          starting.strftime("%a, %b"),
          starting.strftime("%d").to_i.ordinalize.to_s
        ].join(" ")
      end
    elsif (starting.strftime("%h:%M") == ending.strftime("%h:%M")) && (starting.strftime("%d") == ending.strftime("%d"))
      [
        starting.strftime("%a, %h"),
        "#{starting.strftime('%d').to_i.ordinalize},",
        starting.strftime("%l:%M %P")
      ].join(" ")
    # single day event, start and end time
    elsif (starting.strftime("%h") == ending.strftime("%h")) && (starting.strftime("%d") == ending.strftime("%d"))
      "#{
        [
          starting.strftime('%a, %h'),
          "#{starting.strftime('%d').to_i.ordinalize},",
          starting.strftime('%l:%M %P')
        ].join(' ')
      }
      --
        #{ending.strftime('%l:%M %P')}
        "
    elsif ending.strftime("%H") == "00" && (starting.strftime("%d") == ending.strftime("%d")) # multi day event, start but no end time
      "#{
        [
          starting.strftime('%a, %b'),
          "#{starting.strftime('%d').to_i.ordinalize},",
          starting.strftime('%l:%M %P')
        ].join(' ')}
        --
        #{
          [
            ending.strftime('%a, %h'),
            ending.strftime('%d').to_i.ordinalize.to_s
          ].join(' ')}"
    elsif (starting.strftime("%h") == ending.strftime("%h")) && (starting.strftime("%d") != ending.strftime("%d")) # multi day event, same start and end time
      "#{
            [
              starting.strftime('%a, %b'),
              "#{starting.strftime('%d').to_i.ordinalize},",
              starting.strftime('%l:%M %P')
            ].join(' ')}
            --
            #{
              [
                ending.strftime('%a, %h'),
                "#{ending.strftime('%d').to_i.ordinalize},",
                ending.strftime('%l:%M %P')
              ].join(' ')}"
    elsif (starting.strftime("%h") != ending.strftime("%h")) && (starting.strftime("%d") != ending.strftime("%d")) # multi day event, differing start and end time
      "#{
            [
              starting.strftime('%a, %b'),
              "#{starting.strftime('%d').to_i.ordinalize},",
              starting.strftime('%l:%M %P')
            ].join(' ')}
            --
            #{
              [
                ending.strftime('%a, %h'),
                "#{ending.strftime('%d').to_i.ordinalize},",
                ending.strftime('%l:%M %P')
              ].join(' ')}"
    end
  end
end
