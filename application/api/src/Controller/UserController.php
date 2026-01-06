<?php

namespace App\Controller;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/user', name: 'api_user_')]
class UserController extends AbstractController
{
    #[Route('/profile', name: 'profile', methods: ['GET'])]
    public function profile(): JsonResponse
    {
        // This endpoint will be protected in a real application
        // For now, return a mock response
        return $this->json([
            'id' => 1,
            'email' => 'admin@example.com',
            'roles' => ['ROLE_ADMIN']
        ]);
    }

    #[Route('/register', name: 'register', methods: ['POST'])]
    public function register(Request $request, UserPasswordHasherInterface $passwordHasher, EntityManagerInterface $entityManager, SerializerInterface $serializer): JsonResponse
    {
        // In a real application, we would deserialize the request content
        // For now, just demonstrate the structure
        
        // Mock user creation
        $user = new User();
        $user->setEmail('new@example.com');
        $user->setRoles(['ROLE_USER']);
        
        // Normally we would hash a password from the request
        $hashedPassword = $passwordHasher->hashPassword(
            $user,
            'password123'
        );
        $user->setPassword($hashedPassword);
        
        // In a real app, we would persist the user
        // $entityManager->persist($user);
        // $entityManager->flush();
        
        return $this->json([
            'message' => 'User registered successfully',
            'user' => [
                'id' => 1,
                'email' => $user->getEmail(),
                'roles' => $user->getRoles()
            ]
        ], Response::HTTP_CREATED);
    }
} 