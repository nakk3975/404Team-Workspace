package com.weather.main.contoller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/weather")
public class MainController {

	@GetMapping("/main/view")
	public String home() {
		return "main/index";
	}
}
