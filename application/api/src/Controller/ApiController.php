<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api', name: 'api_')]
class ApiController extends AbstractController
{
    #[Route('/info', name: 'info', methods: ['GET'])]
    public function info(): JsonResponse
    {
        return $this->json([
            'name' => 'Angular Symfony Boilerplate API',
            'version' => '1.0.0',
            'symfony_version' => \Symfony\Component\HttpKernel\Kernel::VERSION,
            'php_version' => PHP_VERSION,
        ]);
    }

    #[Route('/features', name: 'features', methods: ['GET'])]
    public function features(): JsonResponse
    {
        return $this->json([
            'features' => [
                'Angular 17+ frontend',
                'Symfony 7+ backend',
                'REST API',
                'Docker ready',
            ],
        ]);
    }
} 