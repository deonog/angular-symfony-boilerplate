<?php

namespace App\Controller;

use App\Entity\User;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Core\Exception\AuthenticationException;

#[Route('/api', name: 'api_auth_')]
class AuthController extends AbstractController
{
    #[Route('/login', name: 'login', methods: ['POST'])]
    public function login(Request $request): JsonResponse
    {
        // In a real application, this would use Symfony's security system
        // For now, we'll just mock a response
        
        try {
            $data = json_decode($request->getContent(), true);
            
            // Mock validation
            if (!isset($data['email']) || !isset($data['password'])) {
                return $this->json(['message' => 'Email and password are required'], Response::HTTP_BAD_REQUEST);
            }
            
            // Mock authentication
            if ($data['email'] === 'admin@example.com' && $data['password'] === 'password') {
                return $this->json([
                    'token' => 'mock_jwt_token_' . time(),
                    'user' => [
                        'id' => 1,
                        'email' => 'admin@example.com',
                        'roles' => ['ROLE_ADMIN']
                    ]
                ]);
            }
            
            throw new AuthenticationException('Invalid credentials');
        } catch (AuthenticationException $e) {
            return $this->json(['message' => $e->getMessage()], Response::HTTP_UNAUTHORIZED);
        } catch (\Exception $e) {
            return $this->json(['message' => 'An error occurred during authentication'], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
    }
    
    #[Route('/logout', name: 'logout', methods: ['POST'])]
    public function logout(): JsonResponse
    {
        // In a real app, logout would be handled by Symfony's security system
        return $this->json(['message' => 'Logged out successfully']);
    }
} 