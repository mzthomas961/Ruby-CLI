User.destroy_all
ForumThread.destroy_all
Reply.destroy_all
User.reset_pk_sequence
ForumThread.reset_pk_sequence
Reply.reset_pk_sequence

easy = User.create(username: "11", password: "222222")
james = User.create(username: "james123", password: "jamesjamesjames")
will = User.create(username: "william456", password: "willx3")
matt = User.create(username: "mzthomas96", password: "socialsecurity")

thread1 = ForumThread.create(title: "my dog is sick!", body: "my dog is super sick",user_id:james.id)
reply1 = Reply.create(forum_thread_id:thread1.id,user_id: will.id, body: "get rekt")
reply2 = Reply.create(forum_thread_id:thread1.id, user_id:matt.id, body: "sorry about that Will guy")
reply3 = Reply.create(forum_thread_id:thread1.id, user_id:james.id, body: "go to the vet, dummy")

thread2 = ForumThread.create(title: "wow cool forum", body: "super great forum guys", user_id: easy.id)
reply4 = Reply.create(forum_thread_id: thread2.id, user_id: will.id, body: "i agree")




# # THIS SEED FILE NEEDS TO BE ENTIRELY REPLACED -- I'M LEAVING CODE FOR YOUR REFERENCE ONLY!

# Plant.destroy_all
# Person.destroy_all
# PlantParenthood.destroy_all
# Plant.reset_pk_sequence
# Person.reset_pk_sequence
# PlantParenthood.reset_pk_sequence

# ########### different ways to write your seeds ############

# # 1: save everything to variables (makes it easy to connect models, best for when you want to be intentional about your seeds)
# basil = Plant.create(name: "basil the herb", bought: 20200610, color: "green")
# sylwia = Person.create(name: "Sylwia", free_time: "none", age: 30)
# pp1 = PlantParenthood.create(plant_id: basil.id, person_id: sylwia.id, affection: 1_000_000, favorite?: true)

# # 2. Mass create -- in order to connect them later IN SEEDS (not through the app) you'll need to find their id
# ## a. by passing an array of hashes:
# Plant.create([
#     {name: "Corn Tree", bought: 20170203, color: "green"},
#     {name: "Prayer plant", bought: 20190815, color: "purple"},
#     {name: "Cactus", bought: 20200110, color: "ugly green"}
# ])
# ## b. by interating over an array of hashes:
# plants = [{name: "Elephant bush", bought: 20180908, color: "green"},
#     {name: "Photos", bought: 20170910, color: "green"},
#     {name: "Dragon tree", bought: 20170910, color: "green"},
#     {name: "Snake plant", bought: 20170910, color: "dark green"},
#     {name: "polka dot plant", bought: 20170915, color: "pink and green"},
#     {name: "Cactus", bought: 20200517, color: "green"}]

# plants.each{|hash| Plant.create(hash)}

# # 3. Use Faker and mass create
# ## step 1: write a method that creates a person
# def create_person
#     free = ["mornings", "evenings", "always", "afternoons", "weekends", "none"].sample

#     person = Person.create(
#         name: Faker::Movies::HitchhikersGuideToTheGalaxy.character,
#         free_time: free,
#         age: rand(11...70)
#     )
# end

# ## step 2: write a method that creates a joiner
# def create_joiners(person)
#     plants_number = rand(1..4)
#     plants_number.times do 
#         PlantParenthood.create(
#             plant_id: Plant.all.sample.id, 
#             person_id: person.id, 
#             affection: rand(101), 
#             favorite?: [true, false].sample
#         )
#     end
# end

# ## step 3: invoke creating joiners by passing in an instance of a person
# 10.times do     
#     create_joiners(create_person)
#     ##### ALTERNATIVE:
#     # person = create_person
#     # create_joiners(person)
# end

# indoor = Category.create(name: "indoors")

# Plant.update(category_id: indoor.id)


puts "🔥 🔥 🔥 🔥 "

