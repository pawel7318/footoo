def remove_slides_from_page(to_delete_array, to_leave_array)
  to_delete_array.map { |slide| 
    page.check("slide_select_#{slide.id}")
  } 

  yield
  
  to_leave_array.map { |slide|
    expect(page).to have_selector("tr#slide_#{slide.id}")
    expect(page).to have_field("slide_select_#{slide.id}")    
  }
  to_delete_array.map {|slide|
    expect(page).to_not have_selector("tr#slide_#{slide.id}")
    expect(page).to_not have_field("slide_select_#{slide.id}")    
  }        
end
