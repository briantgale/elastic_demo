class ReportsController < ApplicationController
  def db
    respond_to do |format|
      format.html {
        @people = Person.all.includes(:profiles)
      }
      format.csv {
        headers["Content-Type"] = "text/csv"
        headers["Content-Disposition"] = "attachment; filename=download_db.csv"
        headers['X-Accel-Buffering'] = 'no'
        headers["Cache-Control"] ||= "no-cache"
        headers.delete("Content-Length")
        self.response_body = Person.db_report_rows
      }
    end
  end

  def es
    respond_to do |format|
      format.html {
        @people = Person.es_report_rows
      }
      format.csv {
        headers["Content-Type"] = "text/csv"
        headers["Content-Disposition"] = "attachment; filename=download_db.csv"
        headers['X-Accel-Buffering'] = 'no'
        headers["Cache-Control"] ||= "no-cache"
        headers.delete("Content-Length")
        self.response_body = Person.es_report_rows
      }
    end
  end
end
