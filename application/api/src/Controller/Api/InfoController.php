<?php

namespace App\Controller\Api;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class InfoController extends AbstractController
{
    #[Route('/info', name: 'api_info', methods: ['GET'])]
    public function index(): JsonResponse
    {
        return new JsonResponse([
            'app' => 'Angular Symfony Boilerplate',
            'version' => '1.0.0',
            'status' => 'running',
            'environment' => $_ENV['APP_ENV'] ?? 'unknown',
            'timestamp' => new \DateTime(),
        ]);
    }
} 