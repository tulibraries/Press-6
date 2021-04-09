# frozen_string_literal: true

module ApplicationHelper
  def search_glass
    asset_pack_path("media/images/mag.png")
  end
  def get_journals
    Journal.all
  end
  def us_states
    [
      ["Alabama", "AL"],
      ["Alaska", "AK"],
      ["Arizona", "AZ"],
      ["Arkansas", "AR"],
      ["California", "CA"],
      ["Colorado", "CO"],
      ["Connecticut", "CT"],
      ["Delaware", "DE"],
      ["District of Columbia", "DC"],
      ["Florida", "FL"],
      ["Georgia", "GA"],
      ["Hawaii", "HI"],
      ["Idaho", "ID"],
      ["Illinois", "IL"],
      ["Indiana", "IN"],
      ["Iowa", "IA"],
      ["Kansas", "KS"],
      ["Kentucky", "KY"],
      ["Louisiana", "LA"],
      ["Maine", "ME"],
      ["Maryland", "MD"],
      ["Massachusetts", "MA"],
      ["Michigan", "MI"],
      ["Minnesota", "MN"],
      ["Mississippi", "MS"],
      ["Missouri", "MO"],
      ["Montana", "MT"],
      ["Nebraska", "NE"],
      ["Nevada", "NV"],
      ["New Hampshire", "NH"],
      ["New Jersey", "NJ"],
      ["New Mexico", "NM"],
      ["New York", "NY"],
      ["North Carolina", "NC"],
      ["North Dakota", "ND"],
      ["Ohio", "OH"],
      ["Oklahoma", "OK"],
      ["Oregon", "OR"],
      ["Pennsylvania", "PA"],
      ["Puerto Rico", "PR"],
      ["Rhode Island", "RI"],
      ["South Carolina", "SC"],
      ["South Dakota", "SD"],
      ["Tennessee", "TN"],
      ["Texas", "TX"],
      ["Utah", "UT"],
      ["Vermont", "VT"],
      ["Virginia", "VA"],
      ["Washington", "WA"],
      ["West Virginia", "WV"],
      ["Wisconsin", "WI"],
      ["Wyoming", "WY"]
    ]
end
  def set_month
    [
      ["January", "01"],
      ["February", "02"],
      ["March", "03"],
      ["April", "04"],
      ["May", "05"],
      ["June", "06"],
      ["July", "07"],
      ["August", "08"],
      ["September", "09"],
      ["October", "10"],
      ["November", "11"],
      ["December", "12"]
    ]
  end
  def get_region(id)
    region = Region.find_by(id: id)
    region.region
  end
  
  # Close unclosed tags
  def fix_invalid_html(html)
    Nokogiri::HTML::DocumentFragment.parse(html).to_html
  end
end
