class TimeDataFormatter
  def format_time time_in_seconds
    mm, ss = time_in_seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    format('%d days, %d hours, %d minutes and %d seconds', dd, hh, mm, ss)
  end
end
