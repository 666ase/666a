xml.instruct!
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc "https://666a.se/"
    xml.lastmod Time.utc(2023, 10, 31).strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end

  @legal_documents.each do |d|
    r = d.revisions.published.last

    if r.nil?
      next
    end

    xml.url do
      xml.loc "https://666a.se#{labour_law_revision_path(d.document_slug, r.revision_code)}"
      xml.lastmod r.updated_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
    end

    r.elements.section_heading.each do |e|
      xml.url do
        xml.loc "https://666a.se#{labour_law_element_path(d.document_slug, r.revision_code, e.element_slug)}"
        xml.lastmod e.updated_at.strftime("%Y-%m-%dT%H:%M:%S+00:00")
      end
    end
  end
end
