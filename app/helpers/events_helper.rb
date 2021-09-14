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
    starting.strftime("%H") == "00" ?

    # multi-day event
    if (starting.strftime("%d") != ending.strftime("%d"))
      "#{
      [
        starting.strftime("%a, %b"),
        "#{starting.strftime("%d").to_i.ordinalize}"
        ].join(" ")}
      -
      #{
        [
          ending.strftime("%a, %h"),
          "#{ending.strftime("%d").to_i.ordinalize}"
        ].join(" ")}"
    else # single day event
      [
        starting.strftime("%a, %b"),
        "#{starting.strftime("%d").to_i.ordinalize}"
      ].join(" ")
    end

    :  # display times

    # single day event, no end time
    if (starting.strftime("%h") == ending.strftime("%h")) && (starting.strftime("%d") == ending.strftime("%d"))
      [
        starting.strftime("%a, %h"),
        "#{starting.strftime("%d").to_i.ordinalize},",
        starting.strftime("%l %P")
      ].join(" ")
    # single day event, start and end time
    elsif
      (starting.strftime("%h") == ending.strftime("%h")) && (starting.strftime("%d") == ending.strftime("%d"))
      "#{
        [
          starting.strftime("%a, %h"),
          "#{starting.strftime("%d").to_i.ordinalize},",
          starting.strftime("%l %P")
        ].join(" ")
        }
      -
        #{
        [
          ending.strftime("%a %h"),
          "#{ending.strftime("%d").to_i.ordinalize},"
        ].join(" ")}"
    elsif # multi day event, start but no end time
      ending.strftime("%H") == "00" && (starting.strftime("%d") == ending.strftime("%d"))
      "#{
        [
          starting.strftime("%a, %b"),
          "#{starting.strftime("%d").to_i.ordinalize},",
          starting.strftime("%l %P")
          ].join(" ")}
        -
        #{
          [
            ending.strftime("%a, %h"),
            "#{ending.strftime("%d").to_i.ordinalize}"
          ].join(" ")}"
        elsif # multi day event, same start and end time
          (starting.strftime("%h") == ending.strftime("%h")) && (starting.strftime("%d") != ending.strftime("%d"))
          "#{
            [
              starting.strftime("%a, %b"),
              "#{starting.strftime("%d").to_i.ordinalize},",
              starting.strftime("%l %P")
              ].join(" ")}
            -
            #{
              [
                ending.strftime("%a, %h"),
                "#{ending.strftime("%d").to_i.ordinalize},",
                ending.strftime("%l %P")
              ].join(" ")}"
        elsif # multi day event, differing start and end time
          (starting.strftime("%h") != ending.strftime("%h")) && (starting.strftime("%d") != ending.strftime("%d"))
          "#{
            [
              starting.strftime("%a, %b"),
              "#{starting.strftime("%d").to_i.ordinalize},",
              starting.strftime("%l %P")
              ].join(" ")}
            -
            #{
              [
                ending.strftime("%a, %h"),
                "#{ending.strftime("%d").to_i.ordinalize},",
                ending.strftime("%l %P")
              ].join(" ")}"
    end
  end
end
