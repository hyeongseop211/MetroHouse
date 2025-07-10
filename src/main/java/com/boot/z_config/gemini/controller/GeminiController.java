package com.boot.z_config.gemini.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.boot.z_config.gemini.service.GeminiService;

import java.util.Map;

@RestController
@RequestMapping("/chatbot")
public class GeminiController {

    @Autowired
    private GeminiService service;

    @PostMapping("/ask")
    public Map<String, String> ask(@RequestBody Map<String, String> request) {
        String question = request.get("message");
        String geminiResponse = service.getGeminiResponse(question);
        return Map.of("reply", geminiResponse);
    }
}

