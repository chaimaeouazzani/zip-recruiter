task scrape: :environment do
  require 'open-uri'
 
  # Link mình muốn vào
  URL_BASIC = 'https://www.topcv.vn/viec-lam-tot-nhat'
 
  # Cho Nokogiri open url và inspect nó
  doc_basic = Nokogiri::HTML(open(URL_BASIC))
  
  # Đếm số trang cần crawl
  pages = doc_basic.search('ul.pagination gt li').count - 2
 
  # Bắt đầu crawl từng page với index là i
  (1..pages).each do |i|
    URL = "https://www.topcv.vn/viec-lam-tot-nhat?page=#{i}"
    doc = Nokogiri::HTML(open(URL))
    postings = doc.search('div.result-job-hover')
 
    postings.each do |p|
      # Lấy thông tin từng field mình mong muốn theo tag html
      job_title = remove_n_string(p.search('div &gt; div &gt; h4.job-title &gt; a &gt; span.bold.transform-job-title').text)
      url = remove_n_string(p.search('div &gt; div &gt; h4.job-title &gt; a')[0]['href'])
      company = remove_n_string(p.search('div &gt; div &gt; div.row-company').text)
      location = remove_n_string(p.search('div &gt; div &gt; div#row-result-info-job &gt; div.address')[0].text)
 
      # Bỏ qua các job đã tồn tại trong database
      if Job.where(title: job_title, location: location, company: company).count &lt= 0
        Job.create(
          title: job_title,
          location: location,
          company: company,
          url: url
        )
        puts 'Added: ' + (job_title ? job_title : '')
      else
        puts 'Skipped: ' + (job_title ? job_title : '')
      end
    end
  end
end
 
# Loại bỏ n chứa trong string
def remove_n_string string
  string.gsub("n","")
end
 